import Virtualization

let dir = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
// let kernelURL = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: false)
// let initialRamdiskURL = URL(fileURLWithPath: CommandLine.arguments[2], isDirectory: false)
let kernelURL = dir.appendingPathComponent("vmlinuz")
let initialRamdiskURL = dir.appendingPathComponent("initrd")
let efiVariableStoreURL = dir.appendingPathComponent("NVRAM")
let efiVariableStorePath = efiVariableStoreURL.path
let machineIdentifierURL = dir.appendingPathComponent("MachineIdentifier")
let machineIdentifierPath = machineIdentifierURL.path
let vdaURL = dir.appendingPathComponent("vda.img")
let vdbURL = dir.appendingPathComponent("vdb.img")
let vdcURL = dir.appendingPathComponent("vdc.iso")
let macAddressURL = dir.appendingPathComponent(".virt.mac")

let hasKernel = FileManager.default.fileExists(atPath: kernelURL.path)
let hasInitialRamdisk = FileManager.default.fileExists(atPath: initialRamdiskURL.path)
let hasEfiVariableStore = FileManager.default.fileExists(atPath: efiVariableStorePath)
let hasMachineIdentifier = FileManager.default.fileExists(atPath: machineIdentifierPath)
let hasVdb = FileManager.default.fileExists(atPath: vdbURL.path)
let hasVdc = FileManager.default.fileExists(atPath: vdcURL.path)

// create the virtual machine configuration
let configuration = VZVirtualMachineConfiguration()
configuration.cpuCount = 4
configuration.memorySize = 8 * 1024 * 1024 * 1024  // 8 GiB

let network = VZVirtioNetworkDeviceConfiguration()
if let macAddressString = try? String(contentsOfFile: macAddressURL.path, encoding: .utf8),
  let macAddress = VZMACAddress(
    string: macAddressString.trimmingCharacters(in: .whitespacesAndNewlines))
{
  network.macAddress = macAddress
} else {
  let macAddressString = network.macAddress.string
  print("Using new MAC Address \(macAddressString)")
  do {
    try macAddressString.write(toFile: macAddressURL.path, atomically: false, encoding: .utf8)
  } catch {
    fatalError("Virtual Machine Config Error: \(error)")
  }
}
network.attachment = VZNATNetworkDeviceAttachment()
configuration.networkDevices = [network]

// creates a serial configuration object for a virtio console device,
// and attaches it to stdin and stdout
let consoleConfiguration = VZVirtioConsoleDeviceSerialPortConfiguration()

let inputFileHandle = FileHandle.standardInput
let outputFileHandle = FileHandle.standardOutput

// put stdin into raw mode, disabling local echo, input canonicalization, and CR-NL mapping
var attributes = termios()
tcgetattr(inputFileHandle.fileDescriptor, &attributes)
attributes.c_iflag &= ~tcflag_t(ICRNL)
attributes.c_lflag &= ~tcflag_t(ECHO | ICANON | ISIG)
tcsetattr(inputFileHandle.fileDescriptor, TCSANOW, &attributes)

let stdioAttachment = VZFileHandleSerialPortAttachment(
  fileHandleForReading: inputFileHandle,
  fileHandleForWriting: outputFileHandle)

consoleConfiguration.attachment = stdioAttachment

configuration.serialPorts = [consoleConfiguration]

let vda = try VZDiskImageStorageDeviceAttachment(url: vdaURL, readOnly: false)
configuration.storageDevices = [VZVirtioBlockDeviceConfiguration(attachment: vda)]
if hasVdb {
  let vdb = try VZDiskImageStorageDeviceAttachment(url: vdbURL, readOnly: false)
  configuration.storageDevices.append(VZVirtioBlockDeviceConfiguration(attachment: vdb))
}
if hasVdc {
  let vdc = try VZDiskImageStorageDeviceAttachment(url: vdcURL, readOnly: true)
  configuration.storageDevices.append(VZVirtioBlockDeviceConfiguration(attachment: vdc))
}

configuration.entropyDevices = [VZVirtioEntropyDeviceConfiguration()]

// let cwd = VZVirtioFileSystemDeviceConfiguration(tag: "cwd")
// cwd.share = VZSingleDirectoryShare(
//   directory: VZSharedDirectory(
//     url: URL(fileURLWithPath: FileManager.default.currentDirectoryPath), readOnly: false))
// let home = VZVirtioFileSystemDeviceConfiguration(tag: "home")
// home.share = VZSingleDirectoryShare(
//   directory: VZSharedDirectory(
//     url: FileManager.default.homeDirectoryForCurrentUser, readOnly: false))
// configuration.directorySharingDevices = [cwd, home]

let host = VZVirtioFileSystemDeviceConfiguration(tag: "host")
host.share = VZMultipleDirectoryShare(directories: [
  "cwd": VZSharedDirectory(
    url: URL(fileURLWithPath: FileManager.default.currentDirectoryPath), readOnly: false),
  "home": VZSharedDirectory(
    url: FileManager.default.homeDirectoryForCurrentUser, readOnly: false),
])
configuration.directorySharingDevices = [host]

if hasKernel {
  // creates a linux bootloader with the given kernel and initial ramdisk
  let bootLoader = VZLinuxBootLoader(kernelURL: kernelURL)
  if hasInitialRamdisk {
    bootLoader.initialRamdiskURL = initialRamdiskURL
  }
  let kernelCommandLineArguments = [
    // use the first virtio console device as system console
    "console=hvc0",
    // stop in the initial ramdisk before attempting to transition to the root file system
    // "rd.break=initqueue",
    // boot from /dev/vda
    "root=/dev/vda",
  ]
  bootLoader.commandLine = kernelCommandLineArguments.joined(separator: " ")
  configuration.bootLoader = bootLoader
} else {
  func createAndSaveMachineIdentifier() -> VZGenericMachineIdentifier {
    let machineIdentifier = VZGenericMachineIdentifier()
    // store the machine identifier to disk so you can retrieve it for subsequent boots.
    try! machineIdentifier.dataRepresentation.write(to: URL(fileURLWithPath: machineIdentifierPath))
    return machineIdentifier
  }
  func retrieveMachineIdentifier() -> VZGenericMachineIdentifier {
    // retrieve the machine identifier.
    guard
      let machineIdentifierData = try? Data(contentsOf: URL(fileURLWithPath: machineIdentifierPath))
    else {
      fatalError("Failed to retrieve the machine identifier data.")
    }
    guard
      let machineIdentifier = VZGenericMachineIdentifier(dataRepresentation: machineIdentifierData)
    else {
      fatalError("Failed to create the machine identifier.")
    }
    return machineIdentifier
  }
  func createEFIVariableStore() -> VZEFIVariableStore {
    guard
      let efiVariableStore = try? VZEFIVariableStore(
        creatingVariableStoreAt: URL(fileURLWithPath: efiVariableStorePath))
    else {
      fatalError("Failed to create the EFI variable store.")
    }
    return efiVariableStore
  }
  func retrieveEFIVariableStore() -> VZEFIVariableStore {
    if !FileManager.default.fileExists(atPath: efiVariableStorePath) {
      fatalError("EFI variable store does not exist.")
    }
    return VZEFIVariableStore(url: URL(fileURLWithPath: efiVariableStorePath))
  }

  let bootLoader = VZEFIBootLoader()
  let platform = VZGenericPlatformConfiguration()

  if hasEfiVariableStore && hasMachineIdentifier {
    // the VM is booting from a disk image that already has the OS installed.
    // retrieve the machine identifier and EFI variable store that were saved to
    // disk during installation.
    platform.machineIdentifier = retrieveMachineIdentifier()
    bootLoader.variableStore = retrieveEFIVariableStore()
  } else {
    // this is a fresh install: Create a new machine identifier and EFI variable store,
    // and configure a USB mass storage device to boot the ISO image.
    platform.machineIdentifier = createAndSaveMachineIdentifier()
    bootLoader.variableStore = createEFIVariableStore()
  }

  configuration.bootLoader = bootLoader
  configuration.platform = platform
}

do {
  try configuration.validate()
} catch {
  print("Failed to validate the virtual machine configuration. \(error)")
  exit(EXIT_FAILURE)
}

// instantiate and start the virtual machine
let virtualMachine = VZVirtualMachine(configuration: configuration)

let delegate = Delegate()
virtualMachine.delegate = delegate

virtualMachine.start { (result) in
  if case let .failure(error) = result {
    print("Failed to start the virtual machine. \(error)")
    exit(EXIT_FAILURE)
  }
}

RunLoop.main.run(until: Date.distantFuture)

// virtual machine delegate
class Delegate: NSObject {
}

extension Delegate: VZVirtualMachineDelegate {
  func guestDidStop(_ virtualMachine: VZVirtualMachine) {
    print("The guest shut down. Exiting.")
    exit(EXIT_SUCCESS)
  }
}

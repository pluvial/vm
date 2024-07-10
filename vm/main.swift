import Virtualization

let dir = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
// let kernelURL = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: false)
// let initialRamdiskURL = URL(fileURLWithPath: CommandLine.arguments[2], isDirectory: false)
let kernelURL = dir.appendingPathComponent("vmlinuz")
let initialRamdiskURL = dir.appendingPathComponent("initrd")
let vdaURL = dir.appendingPathComponent("vda.img")
let vdbURL = dir.appendingPathComponent("vdb.img")
let vdcURL = dir.appendingPathComponent("vdc.iso")

let hasInitialRamdisk = FileManager.default.fileExists(
  atPath: initialRamdiskURL.path(percentEncoded: false))
let hasVdc = FileManager.default.fileExists(atPath: vdcURL.path(percentEncoded: false))

// create the virtual machine configuration
let configuration = VZVirtualMachineConfiguration()
configuration.cpuCount = 2
configuration.memorySize = 2 * 1024 * 1024 * 1024  // 2 GiB

let network = VZVirtioNetworkDeviceConfiguration()
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
let vdb = try VZDiskImageStorageDeviceAttachment(url: vdbURL, readOnly: false)
configuration.storageDevices = [
  VZVirtioBlockDeviceConfiguration(attachment: vda),
  VZVirtioBlockDeviceConfiguration(attachment: vdb),
]
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

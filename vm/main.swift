import Virtualization

// parse the command line
guard CommandLine.argc == 3 else {
  printUsageAndExit()
}

let kernelURL = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: false)
let initialRamdiskURL = URL(fileURLWithPath: CommandLine.arguments[2], isDirectory: false)

// create the virtual machine configuration
let configuration = VZVirtualMachineConfiguration()
configuration.cpuCount = 2
configuration.memorySize = 2 * 1024 * 1024 * 1024  // 2 GiB

// creates a serial configuration object for a virtio console device,
// and attaches it to stdin and stdout
let consoleConfiguration = VZVirtioConsoleDeviceSerialPortConfiguration()

let inputFileHandle = FileHandle.standardInput
let outputFileHandle = FileHandle.standardOutput

// put stdin into raw mode, disabling local echo, input canonicalization, and CR-NL mapping
var attributes = termios()
tcgetattr(inputFileHandle.fileDescriptor, &attributes)
attributes.c_iflag &= ~tcflag_t(ICRNL)
attributes.c_lflag &= ~tcflag_t(ICANON | ECHO)
tcsetattr(inputFileHandle.fileDescriptor, TCSANOW, &attributes)

let stdioAttachment = VZFileHandleSerialPortAttachment(
  fileHandleForReading: inputFileHandle,
  fileHandleForWriting: outputFileHandle)

consoleConfiguration.attachment = stdioAttachment

configuration.serialPorts = [consoleConfiguration]

// creates a linux bootloader with the given kernel and initial ramdisk
let bootLoader = VZLinuxBootLoader(kernelURL: kernelURL)
bootLoader.initialRamdiskURL = initialRamdiskURL

let kernelCommandLineArguments = [
  // use the first virtio console device as system console
  "console=hvc0",
  // stop in the initial ramdisk before attempting to transition to the root file system
  "rd.break=initqueue",
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

func printUsageAndExit() -> Never {
  print("Usage: \(CommandLine.arguments[0]) <kernel-path> <initial-ramdisk-path>")
  exit(EX_USAGE)
}

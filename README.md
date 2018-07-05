Icinga 2 PowerShell Plugins
==============

This repository provides a bunch of PowerShell Plugins which can be used together with the Icinga 2 Agent.

## Requirements

You will require to have the [Icinga 2 Performance Counter Library](https://github.com/LordHepipud/icinga2-perfcounter-lib) intalled on your system.

## Icinga 2 Check-Command configuration (example)

### Icinga 2 Check Command
```
object CheckCommand "PowerShell" {
    import "plugin-check-command"
    command = [
        "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
    ]
    arguments += {
        "-Arguments" = {
            order = 1
            required = false
            skip_key = true
            value = "$PowerShell_Arguments$"
        }
        "-Command" = {
            order = 0
            required = false
            value = "$PowerShell_Command$"
        }
        "; exit" = {
            order = 99
            value = "$$LASTEXITCODE"
        }
    }
}
```
### Icinga 2 Service Template
```
template Service "Windows Load" {
    import "generic-service"

    check_command = "PowerShell"
    command_endpoint = host_name
}
```

### Icinga 2 Service Object
```
object Service "load" {
    host_name = "windows.example.com"
    import "Windows Load"

    vars.PowerShell_Arguments = "-w 70 -c 85"
    vars.PowerShell_Command = "& 'C:\\Program Files\\ICINGA2\\sbin\\check_load.ps1'"
}
```

*Note:*

The PowerShell Command is the direct path to your Icinga 2 Plugin Directory or whereever you installed these plugins to.

Of course you can create commands for each single PowerShell plugin with direct arguments to access the speficic plugin. This example is a generic proposal, allowing to integrate every single PowerShell plugin without much trouble.
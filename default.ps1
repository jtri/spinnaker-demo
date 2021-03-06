properties {
    $base_dir = $PSScriptRoot
    $logs_dir = "$base_dir\build\logs"
    $build_file = "$base_dir\packer\hyperv.json"
    $nuget = Join-Path $base_dir .nuget\NuGet.exe

    $iso_url = 'C:\users\jim\ISOs\ubuntu-16.04.3-server-amd64.iso'
    $hyperv_switch = 'external_eth1'
}

task default -depends hello_world

task hello_world { echo 'Hello World' }

task chocolatey_install {
    choco install packer -y
}

task init {
    Write-Host "Build logs located at $base_dir\build\logs"
    mkdir $base_dir\build\logs -Force | Out-Null
}

task set_environment {
    $env:HYPERV_SWITCHNAME=$hyperv_switch
    $env:ISO_URL=$iso_url
}

task build_image -depends init, set_environment {
    #if ($debug) {
        echo $env:HYPERV_SWITCHNAME
        echo $env:ISO_URL
        exec { set PACKER_DEBUG=1; packer build $build_file 2>&1 | tee $logs_dir\packer.log }
    #}
    #else {
    #    exec { packer build $build_file 2>&1 | tee $logs_dir\packer.log }
    #}
}
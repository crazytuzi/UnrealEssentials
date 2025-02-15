# Set Working Directory
Split-Path $MyInvocation.MyCommand.Path | Push-Location
[Environment]::CurrentDirectory = $PWD

./Publish.ps1 -ProjectPath "UnrealEssentials/UnrealEssentials.csproj" `
              -PackageName "UnrealEssentials" `
              -PublishOutputDir "Publish/ToUpload/UnrealEssentials" `
			  -ChangelogPath "UnrealEssentials/CHANGELOG.MD" `
              
Remove-Item "Publish/Builds" -Recurse -ErrorAction SilentlyContinue

Push-Location "./UtocEmulator/fileemu-utoc-stream-emulator"
$env:RUSTFLAGS = "-C panic=abort -C lto=fat -C embed-bitcode=yes"
cargo +nightly build --release -Z build-std=std,panic_abort -Z build-std-features=panic_immediate_abort -Z unstable-options --target x86_64-pc-windows-msvc --out-dir "../../Publish/Builds/CurrentVersion"
Pop-Location


./Publish.ps1 -ProjectPath "UtocEmulator/UTOC.Stream.Emulator/UTOC.Stream.Emulator.csproj" `
              -PackageName "UTOC.Stream.Emulator" `
              -PublishOutputDir "Publish/ToUpload/UTOC.Stream.Emulator" `
			  -ChangelogPath "UtocEmulator/CHANGELOG.MD" `
              -CleanBuildDirectory False `

Remove-Item "Publish/Builds" -Recurse -ErrorAction SilentlyContinue

Pop-Location
Invoke-WebRequest https://github.com/SuperCuber/dotter/releases/latest/download/dotter-windows-x64-msvc.exe
New-Item -ItemType Directory bin
Move-Item dotter-windows-x64-msvc.exe bin\dotter.exe

$files = Get-ChildItem .\src\device.*\device.yml
foreach ($file in $files)
{
    Write-Output "Generating schema tables for $file..."
    dotnet run --project .\src\harp.schemaprocessor $file .\apispec
}
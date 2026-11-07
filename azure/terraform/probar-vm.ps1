# Prueba combinaciones de tamano/zona de VM en la region actual hasta que una funcione.
# Solo crea la VM (la red ya existe). Ejecutar desde azure/terraform.
$sizes = @("Standard_B2s_v2", "Standard_B2as_v2", "Standard_B2s", "Standard_D2s_v3", "Standard_B2ms")
$zones = @("1", "2", "3")

foreach ($size in $sizes) {
    foreach ($zone in $zones) {
        Write-Host "`n=== Probando $size en zona $zone ===" -ForegroundColor Cyan
        terraform apply -auto-approve "-var=vm_size=$size" "-var=vm_zone=$zone"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "`nOK: VM creada con $size en zona $zone" -ForegroundColor Green
            Write-Host "Actualiza terraform.tfvars con: vm_size = `"$size`"  y  vm_zone = `"$zone`""
            terraform output public_ip
            exit 0
        }
    }
}
Write-Host "`nNinguna combinacion funciono en esta region. Probar cambiando location a westus2." -ForegroundColor Red
exit 1

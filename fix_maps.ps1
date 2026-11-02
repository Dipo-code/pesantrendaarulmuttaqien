$filePath = 'C:\xampp\htdocs\PesantrenDaarulmuttaqien\index.html'
$lines = [System.IO.File]::ReadAllLines($filePath, [System.Text.Encoding]::UTF8)

# ---- Helper: hapus range baris, return array baru ----
function Remove-Lines($arr, $from, $to) {
    $before = if ($from -gt 0) { $arr[0..($from-1)] } else { @() }
    $after  = if ($to -lt $arr.Length-1) { $arr[($to+1)..($arr.Length-1)] } else { @() }
    return $before + $after
}

# ============================================================
# KAMPUS 1 — baris 516 (0-indexed=515): orphan <div
#             baris 525-550 (0-indexed=524-549): sisa lama
# ============================================================
# Kita hapus baris 516 (orphan div, index 515) DAN baris 525-550 (index 524-549)
# Tapi setelah hapus baris 515, index bergeser -1, jadi baris 525-550 jadi 524-549 → setelah hapus 515 jadi 523-548

# Hapus sisa lama kampus 1 dulu (baris 525-550, index 524-549) - SEBELUM orphan div agar index tidak shift
# Deteksi: cari baris yang dimulai dgn '                                            <div' yg berisi 'absolute inset-0 flex items-center justify-center pointer-events-none'
# Kita akan pakai range fix berdasar output: hapus index 524 s/d 549

$lines = Remove-Lines $lines 524 549   # hapus sisa elemen lama kampus 1 (SVG + pin)
# Sekarang index 515 (orphan div kampus 1) masih ada
$lines = Remove-Lines $lines 515 515   # hapus orphan <div di baris 516

Write-Host "Kampus 1 fixed. Total lines now: $($lines.Length)"

# ============================================================
# KAMPUS 2 — setelah penghapusan di atas, index bergeser -27
# Semula: orphan div = 705 (index 704), sisa lama = 714-739 (index 713-738)
# Setelah -27: orphan div = index 677, sisa lama = index 686-711
# ============================================================
$lines = Remove-Lines $lines 686 711   # hapus sisa elemen lama kampus 2
$lines = Remove-Lines $lines 677 677   # hapus orphan <div kampus 2

Write-Host "Kampus 2 fixed. Total lines now: $($lines.Length)"

[System.IO.File]::WriteAllLines($filePath, $lines, [System.Text.Encoding]::UTF8)
Write-Host "Done! File saved."

<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\laporan;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;

class LaporanController extends Controller
{
    public function index(): JsonResponse
    {
        try {
            $laporan = laporan::with('pengguna')->get();
            return response()->json([
                'success' => true,
                'message' => 'Data laporan berhasil diambil',
                'data' => $laporan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data laporan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'pengguna_id' => 'required|exists:penggunas,id',
                'jenis_laporan' => 'required|string|in:Harian,Mingguan,Bulanan,Tahunan',
                'periode_mulai' => 'required|date',
                'periode_selesai' => 'required|date|after_or_equal:periode_mulai',
                'total_produksi_telur' => 'required|integer|min:0',
                'total_konsumsi_pakan' => 'required|numeric|min:0',
                'total_penjualan' => 'required|numeric|min:0',
                'keuntungan' => 'required|numeric',
                'catatan' => 'nullable|string',
                'status' => 'required|string|in:Draft,Final,Disetujui'
            ]);

            $laporan = laporan::create($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Laporan berhasil ditambahkan',
                'data' => $laporan->load('pengguna')
            ], 201);
        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menambahkan laporan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id): JsonResponse
    {
        try {
            $laporan = laporan::with('pengguna')->findOrFail($id);
            
            return response()->json([
                'success' => true,
                'message' => 'Data laporan berhasil ditemukan',
                'data' => $laporan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Laporan tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function update(Request $request, $id): JsonResponse
    {
        try {
            $laporan = laporan::findOrFail($id);
            
            $validated = $request->validate([
                'pengguna_id' => 'sometimes|exists:penggunas,id',
                'jenis_laporan' => 'sometimes|string|in:Harian,Mingguan,Bulanan,Tahunan',
                'periode_mulai' => 'sometimes|date',
                'periode_selesai' => 'sometimes|date|after_or_equal:periode_mulai',
                'total_produksi_telur' => 'sometimes|integer|min:0',
                'total_konsumsi_pakan' => 'sometimes|numeric|min:0',
                'total_penjualan' => 'sometimes|numeric|min:0',
                'keuntungan' => 'sometimes|numeric',
                'catatan' => 'nullable|string',
                'status' => 'sometimes|string|in:Draft,Final,Disetujui'
            ]);

            $laporan->update($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Laporan berhasil diperbarui',
                'data' => $laporan->load('pengguna')
            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui laporan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id): JsonResponse
    {
        try {
            $laporan = laporan::findOrFail($id);
            $laporan->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Laporan berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus laporan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByPengguna($penggunaId): JsonResponse
    {
        try {
            $laporan = laporan::with('pengguna')
                ->where('pengguna_id', $penggunaId)
                ->orderBy('periode_selesai', 'desc')
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Laporan pengguna berhasil diambil',
                'data' => $laporan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil laporan pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByJenisLaporan($jenisLaporan): JsonResponse
    {
        try {
            $laporan = laporan::with('pengguna')
                ->where('jenis_laporan', $jenisLaporan)
                ->orderBy('periode_selesai', 'desc')
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Laporan berdasarkan jenis berhasil diambil',
                'data' => $laporan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil laporan berdasarkan jenis',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByStatus($status): JsonResponse
    {
        try {
            $laporan = laporan::with('pengguna')
                ->where('status', $status)
                ->orderBy('created_at', 'desc')
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Laporan berdasarkan status berhasil diambil',
                'data' => $laporan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil laporan berdasarkan status',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function generateLaporan(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'pengguna_id' => 'required|exists:penggunas,id',
                'jenis_laporan' => 'required|string|in:Harian,Mingguan,Bulanan,Tahunan',
                'periode_mulai' => 'required|date',
                'periode_selesai' => 'required|date|after_or_equal:periode_mulai'
            ]);

            // Generate laporan berdasarkan data monitoring dan pesanan
            $monitoring = monitoring::where('pengguna_id', $validated['pengguna_id'])
                ->whereBetween('tanggal_monitoring', [$validated['periode_mulai'], $validated['periode_selesai']])
                ->get();

            $pesanan = pesanan::where('pengguna_id', $validated['pengguna_id'])
                ->whereBetween('tanggal_pesanan', [$validated['periode_mulai'], $validated['periode_selesai']])
                ->get();

            $totalProduksiTelur = $monitoring->sum('jumlah_telur_harian');
            $totalKonsumsiPakan = $monitoring->sum('konsumsi_pakan');
            $totalPenjualan = $pesanan->sum('harga_total');
            
            // Asumsi biaya pakan per kg
            $biayaPakan = $totalKonsumsiPakan * 5000; // 5000 per kg
            $keuntungan = $totalPenjualan - $biayaPakan;

            $laporanData = [
                'pengguna_id' => $validated['pengguna_id'],
                'jenis_laporan' => $validated['jenis_laporan'],
                'periode_mulai' => $validated['periode_mulai'],
                'periode_selesai' => $validated['periode_selesai'],
                'total_produksi_telur' => $totalProduksiTelur,
                'total_konsumsi_pakan' => $totalKonsumsiPakan,
                'total_penjualan' => $totalPenjualan,
                'keuntungan' => $keuntungan,
                'status' => 'Draft',
                'catatan' => 'Laporan otomatis dari sistem'
            ];

            $laporan = laporan::create($laporanData);
            
            return response()->json([
                'success' => true,
                'message' => 'Laporan berhasil digenerate',
                'data' => $laporan->load('pengguna')
            ], 201);
        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal generate laporan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function approveLaporan($id): JsonResponse
    {
        try {
            $laporan = laporan::findOrFail($id);
            $laporan->update(['status' => 'Disetujui']);
            
            return response()->json([
                'success' => true,
                'message' => 'Laporan berhasil disetujui',
                'data' => $laporan->load('pengguna')
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyetujui laporan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getStatistikLaporan(): JsonResponse
    {
        try {
            $statistik = [
                'total_laporan' => laporan::count(),
                'laporan_draft' => laporan::where('status', 'Draft')->count(),
                'laporan_final' => laporan::where('status', 'Final')->count(),
                'laporan_disetujui' => laporan::where('status', 'Disetujui')->count(),
                'total_keuntungan_bulan_ini' => laporan::whereMonth('periode_selesai', now()->month)
                    ->whereYear('periode_selesai', now()->year)
                    ->sum('keuntungan'),
                'rata_rata_keuntungan' => laporan::avg('keuntungan')
            ];
            
            return response()->json([
                'success' => true,
                'message' => 'Statistik laporan berhasil diambil',
                'data' => $statistik
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil statistik laporan',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\monitoring;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;

class MonitoringController extends Controller
{
    public function index(): JsonResponse
    {
        try {
            $monitoring = monitoring::with('pengguna')->get();
            return response()->json([
                'success' => true,
                'message' => 'Data monitoring berhasil diambil',
                'data' => $monitoring
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data monitoring',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'pengguna_id' => 'required|exists:penggunas,id',
                'tanggal_monitoring' => 'required|date',
                'suhu' => 'required|numeric',
                'kelembaban' => 'required|numeric|min:0|max:100',
                'kondisi_bebek' => 'required|string',
                'jumlah_telur_harian' => 'required|integer|min:0',
                'konsumsi_pakan' => 'required|numeric|min:0',
                'catatan' => 'nullable|string',
                'status_kesehatan' => 'required|string|in:Sehat,Sakit,Perlu Perhatian'
            ]);

            $monitoring = monitoring::create($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Data monitoring berhasil ditambahkan',
                'data' => $monitoring->load('pengguna')
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
                'message' => 'Gagal menambahkan data monitoring',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id): JsonResponse
    {
        try {
            $monitoring = monitoring::with('pengguna')->findOrFail($id);
            
            return response()->json([
                'success' => true,
                'message' => 'Data monitoring berhasil ditemukan',
                'data' => $monitoring
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Data monitoring tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function update(Request $request, $id): JsonResponse
    {
        try {
            $monitoring = monitoring::findOrFail($id);
            
            $validated = $request->validate([
                'pengguna_id' => 'sometimes|exists:penggunas,id',
                'tanggal_monitoring' => 'sometimes|date',
                'suhu' => 'sometimes|numeric',
                'kelembaban' => 'sometimes|numeric|min:0|max:100',
                'kondisi_bebek' => 'sometimes|string',
                'jumlah_telur_harian' => 'sometimes|integer|min:0',
                'konsumsi_pakan' => 'sometimes|numeric|min:0',
                'catatan' => 'nullable|string',
                'status_kesehatan' => 'sometimes|string|in:Sehat,Sakit,Perlu Perhatian'
            ]);

            $monitoring->update($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Data monitoring berhasil diperbarui',
                'data' => $monitoring->load('pengguna')
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
                'message' => 'Gagal memperbarui data monitoring',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id): JsonResponse
    {
        try {
            $monitoring = monitoring::findOrFail($id);
            $monitoring->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Data monitoring berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus data monitoring',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByPengguna($penggunaId): JsonResponse
    {
        try {
            $monitoring = monitoring::with('pengguna')
                ->where('pengguna_id', $penggunaId)
                ->orderBy('tanggal_monitoring', 'desc')
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Data monitoring pengguna berhasil diambil',
                'data' => $monitoring
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data monitoring pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByDateRange(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'start_date' => 'required|date',
                'end_date' => 'required|date|after_or_equal:start_date',
                'pengguna_id' => 'sometimes|exists:penggunas,id'
            ]);

            $query = monitoring::with('pengguna')
                ->whereBetween('tanggal_monitoring', [$validated['start_date'], $validated['end_date']]);

            if (isset($validated['pengguna_id'])) {
                $query->where('pengguna_id', $validated['pengguna_id']);
            }

            $monitoring = $query->orderBy('tanggal_monitoring', 'desc')->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Data monitoring berdasarkan rentang tanggal berhasil diambil',
                'data' => $monitoring
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
                'message' => 'Gagal mengambil data monitoring berdasarkan rentang tanggal',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getStatistik($penggunaId = null): JsonResponse
    {
        try {
            $query = monitoring::query();
            
            if ($penggunaId) {
                $query->where('pengguna_id', $penggunaId);
            }

            $statistik = [
                'rata_rata_suhu' => $query->avg('suhu'),
                'rata_rata_kelembaban' => $query->avg('kelembaban'),
                'total_telur_bulan_ini' => $query->whereMonth('tanggal_monitoring', now()->month)
                    ->whereYear('tanggal_monitoring', now()->year)
                    ->sum('jumlah_telur_harian'),
                'rata_rata_konsumsi_pakan' => $query->avg('konsumsi_pakan'),
                'jumlah_monitoring_hari_ini' => $query->whereDate('tanggal_monitoring', today())->count(),
                'status_kesehatan_terbaru' => $query->orderBy('tanggal_monitoring', 'desc')
                    ->first()?->status_kesehatan ?? 'Tidak ada data'
            ];
            
            return response()->json([
                'success' => true,
                'message' => 'Statistik monitoring berhasil diambil',
                'data' => $statistik
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil statistik monitoring',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByStatusKesehatan($status): JsonResponse
    {
        try {
            $monitoring = monitoring::with('pengguna')
                ->where('status_kesehatan', $status)
                ->orderBy('tanggal_monitoring', 'desc')
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Data monitoring berdasarkan status kesehatan berhasil diambil',
                'data' => $monitoring
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data monitoring berdasarkan status kesehatan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getLatestMonitoring($penggunaId = null): JsonResponse
    {
        try {
            $query = monitoring::with('pengguna');
            
            if ($penggunaId) {
                $query->where('pengguna_id', $penggunaId);
            }

            $monitoring = $query->orderBy('tanggal_monitoring', 'desc')
                ->orderBy('created_at', 'desc')
                ->first();
            
            return response()->json([
                'success' => true,
                'message' => 'Data monitoring terbaru berhasil diambil',
                'data' => $monitoring
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data monitoring terbaru',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\stoktelur;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;

class StokTelurController extends Controller
{
    // Quality mapping
    private const QUALITY_MAP = [
        'bagus' => 1,
        'sedang' => 2,
        'buruk' => 3
    ];

    private const QUALITY_REVERSE_MAP = [
        1 => 'bagus',
        2 => 'sedang',
        3 => 'buruk'
    ];

    public function index(): JsonResponse
    {
        try {
            $stokTelur = stoktelur::with('pengguna')->get();
            
            // Convert quality integers back to strings
            $stokTelur->transform(function ($item) {
                $item->kualitas = self::QUALITY_REVERSE_MAP[$item->kualitas] ?? $item->kualitas;
                return $item;
            });
            
            return response()->json([
                'success' => true,
                'message' => 'Data stok telur berhasil diambil',
                'data' => $stokTelur
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data stok telur',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'pengguna_id' => 'required|exists:penggunas,id',
                'jumlah_telur' => 'required|integer|min:1',
                'kualitas' => 'required|string|in:bagus,sedang,buruk',
                'tanggal_input' => 'required|date',
                'status' => 'required|string',
                'tanggal_ambil' => 'nullable|date'
            ]);

            // Convert quality string to integer
            $validated['kualitas'] = self::QUALITY_MAP[$validated['kualitas']];

            $stokTelur = stoktelur::create($validated);
            
            // Convert back to string for response
            $stokTelur->kualitas = self::QUALITY_REVERSE_MAP[$stokTelur->kualitas];
            
            return response()->json([
                'success' => true,
                'message' => 'Stok telur berhasil ditambahkan',
                'data' => $stokTelur->load('pengguna')
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
                'message' => 'Gagal menambahkan stok telur',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id): JsonResponse
    {
        try {
            $stokTelur = stoktelur::with('pengguna')->findOrFail($id);
            
            // Convert quality integer back to string
            $stokTelur->kualitas = self::QUALITY_REVERSE_MAP[$stokTelur->kualitas] ?? $stokTelur->kualitas;
            
            return response()->json([
                'success' => true,
                'message' => 'Data stok telur berhasil ditemukan',
                'data' => $stokTelur
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Stok telur tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function update(Request $request, $id): JsonResponse
    {
        try {
            $stokTelur = stoktelur::findOrFail($id);
            
            $validated = $request->validate([
                'pengguna_id' => 'sometimes|exists:penggunas,id',
                'jumlah_telur' => 'sometimes|integer|min:1',
                'kualitas' => 'sometimes|string|in:bagus,sedang,buruk',
                'tanggal_input' => 'sometimes|date',
                'status' => 'sometimes|string',
                'tanggal_ambil' => 'nullable|date'
            ]);

            // Convert quality string to integer if provided
            if (isset($validated['kualitas'])) {
                $validated['kualitas'] = self::QUALITY_MAP[$validated['kualitas']];
            }

            $stokTelur->update($validated);
            
            // Convert back to string for response
            $stokTelur->kualitas = self::QUALITY_REVERSE_MAP[$stokTelur->kualitas];
            
            return response()->json([
                'success' => true,
                'message' => 'Stok telur berhasil diperbarui',
                'data' => $stokTelur->load('pengguna')
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
                'message' => 'Gagal memperbarui stok telur',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id): JsonResponse
    {
        try {
            $stokTelur = stoktelur::findOrFail($id);
            $stokTelur->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Stok telur berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus stok telur',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByPengguna($penggunaId): JsonResponse
    {
        try {
            $stokTelur = stoktelur::with('pengguna')
                ->where('pengguna_id', $penggunaId)
                ->get();
            
            // Convert quality integers back to strings
            $stokTelur->transform(function ($item) {
                $item->kualitas = self::QUALITY_REVERSE_MAP[$item->kualitas] ?? $item->kualitas;
                return $item;
            });
            
            return response()->json([
                'success' => true,
                'message' => 'Stok telur pengguna berhasil diambil',
                'data' => $stokTelur
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil stok telur pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getTotalTelur(): JsonResponse
    {
        try {
            $total = stoktelur::sum('jumlah_telur');
            
            return response()->json([
                'success' => true,
                'message' => 'Total stok telur berhasil dihitung',
                'data' => [
                    'total_stok_telur' => $total
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghitung total stok telur',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByKualitas($kualitas): JsonResponse
    {
        try {
            // Convert string quality to integer for database query
            $kualitasInt = self::QUALITY_MAP[$kualitas] ?? null;
            
            if ($kualitasInt === null) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kualitas tidak valid'
                ], 400);
            }   
            
            $stokTelur = stoktelur::with('pengguna')
                ->where('kualitas', $kualitasInt)
                ->get();
            
            // Convert quality integers back to strings
            $stokTelur->transform(function ($item) {
                $item->kualitas = self::QUALITY_REVERSE_MAP[$item->kualitas] ?? $item->kualitas;
                return $item;
            });
            
            return response()->json([
                'success' => true,
                'message' => 'Stok telur berdasarkan kualitas berhasil diambil',
                'data' => $stokTelur
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil stok telur berdasarkan kualitas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getStokByDate(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'start_date' => 'required|date',
                'end_date' => 'required|date|after_or_equal:start_date'
            ]);

            $stokTelur = stoktelur::with('pengguna')
                ->whereBetween('tanggal_input', [$validated['start_date'], $validated['end_date']])
                ->get();
            
            // Convert quality integers back to strings
            $stokTelur->transform(function ($item) {
                $item->kualitas = self::QUALITY_REVERSE_MAP[$item->kualitas] ?? $item->kualitas;
                return $item;
            });
            
            return response()->json([
                'success' => true,
                'message' => 'Stok telur berdasarkan tanggal berhasil diambil',
                'data' => $stokTelur
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
                'message' => 'Gagal mengambil stok telur berdasarkan tanggal',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
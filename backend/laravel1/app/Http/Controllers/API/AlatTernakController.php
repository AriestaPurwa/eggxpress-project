<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\alatternak;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Log;

class AlatTernakController extends Controller
{
    public function index(): JsonResponse
    {
        try {
            $alatTernak = alatternak::with('pengguna')->get();
            return response()->json([
                'success' => true,
                'message' => 'Data alat ternak berhasil diambil',
                'data' => $alatTernak
            ], 200);
        } catch (\Exception $e) {
            Log::error('Error in index: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data alat ternak',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request): JsonResponse
    {
        try {
            // Log request data untuk debugging
            Log::info('Store request data: ', $request->all());
            
            // Validasi basic terlebih dahulu
            $validated = $request->validate([
                'pengguna_id' => 'required|integer',
                'nama_alat' => 'required|string|max:255',
                'jumlah_alat' => 'required|integer|min:1',
                'tanggal_input' => 'required|date',
                'status' => 'required|string|max:50',
                'tanggal_ambil' => 'nullable|date',
            ]);

            Log::info('Validated data: ', $validated);

            // Cek apakah pengguna_id exists (manual check)
            $penggunaExists = \DB::table('penggunas')->where('id', $validated['pengguna_id'])->exists();
            if (!$penggunaExists) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengguna ID tidak ditemukan',
                    'error' => 'pengguna_id tidak valid'
                ], 422);
            }

            $alatTernak = alatternak::create($validated);
            
            Log::info('Created alat ternak: ', $alatTernak->toArray());
            
            return response()->json([
                'success' => true,
                'message' => 'Alat ternak berhasil ditambahkan',
                'data' => $alatTernak->load('pengguna')
            ], 201);
            
        } catch (ValidationException $e) {
            Log::error('Validation error: ', $e->errors());
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            Log::error('Store error: ' . $e->getMessage());
            Log::error('Stack trace: ' . $e->getTraceAsString());
            return response()->json([
                'success' => false,
                'message' => 'Gagal menambahkan alat ternak',
                'error' => $e->getMessage(),
                'line' => $e->getLine(),
                'file' => $e->getFile()
            ], 500);
        }
    }

    public function show($id): JsonResponse
    {
        try {
            $alatTernak = alatternak::with('pengguna')->findOrFail($id);
            
            return response()->json([
                'success' => true,
                'message' => 'Data alat ternak berhasil ditemukan',
                'data' => $alatTernak
            ], 200);
        } catch (\Exception $e) {
            Log::error('Show error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Alat ternak tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function update(Request $request, $id): JsonResponse
    {
        try {
            $alatTernak = alatternak::findOrFail($id);
            
            $validated = $request->validate([
                'pengguna_id' => 'sometimes|integer',
                'nama_alat' => 'sometimes|string|max:255',
                'jumlah_alat' => 'sometimes|integer|min:1',
                'tanggal_input' => 'sometimes|date',
                'status' => 'sometimes|string|max:50',
                'tanggal_ambil' => 'nullable|date',
            ]);

            $alatTernak->update($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Alat ternak berhasil diperbarui',
                'data' => $alatTernak->load('pengguna')
            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            Log::error('Update error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui alat ternak',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id): JsonResponse
    {
        try {
            $alatTernak = alatternak::findOrFail($id);
            $alatTernak->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Alat ternak berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            Log::error('Delete error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus alat ternak',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByPengguna($penggunaId): JsonResponse
    {
        try {
            $alatTernak = alatternak::with('pengguna')
                ->where('pengguna_id', $penggunaId)
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Data alat ternak pengguna berhasil diambil',
                'data' => $alatTernak
            ], 200);
        } catch (\Exception $e) {
            Log::error('GetByPengguna error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data alat ternak pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}






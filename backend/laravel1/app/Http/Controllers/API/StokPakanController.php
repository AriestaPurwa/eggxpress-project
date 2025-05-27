<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\stokpakan;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;

class StokPakanController extends Controller
{
    public function index(): JsonResponse
    {
        try {
            $stokPakan = stokpakan::with('pengguna')->get();
            return response()->json([
                'success' => true,
                'message' => 'Data stok pakan berhasil diambil',
                'data' => $stokPakan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data stok pakan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'pengguna_id' => 'required|exists:penggunas,id',
                'nama_pakan' => 'required|string|max:255',
                'jumlah_pakan' => 'required|integer|min:1',
                'tanggal_input' => 'required|date',
                'status' => 'required|string',
                'tanggal_ambil' => 'nullable|date'
            ]);

            $stokPakan = stokpakan::create($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Stok pakan berhasil ditambahkan',
                'data' => $stokPakan->load('pengguna')
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
                'message' => 'Gagal menambahkan stok pakan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id): JsonResponse
    {
        try {
            $stokPakan = stokpakan::with('pengguna')->findOrFail($id);
            
            return response()->json([
                'success' => true,
                'message' => 'Data stok pakan berhasil ditemukan',
                'data' => $stokPakan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Stok pakan tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function update(Request $request, $id): JsonResponse
    {
        try {
            $stokPakan = stokpakan::findOrFail($id);
            
            $validated = $request->validate([
                'pengguna_id' => 'sometimes|exists:penggunas,id',
                'nama_pakan' => 'sometimes|string|max:255',
                'jumlah_pakan' => 'sometimes|integer|min:1',
                'tanggal_input' => 'sometimes|date',
                'status' => 'sometimes|string',
                'tanggal_ambil' => 'nullable|date'
            ]);

            $stokPakan->update($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Stok pakan berhasil diperbarui',
                'data' => $stokPakan->load('pengguna')
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
                'message' => 'Gagal memperbarui stok pakan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id): JsonResponse
    {
        try {
            $stokPakan = stokpakan::findOrFail($id);
            $stokPakan->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Stok pakan berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus stok pakan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByPengguna($penggunaId): JsonResponse
    {
        try {
            $stokPakan = stokpakan::with('pengguna')
                ->where('pengguna_id', $penggunaId)
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Stok pakan pengguna berhasil diambil',
                'data' => $stokPakan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil stok pakan pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getTotalStok(): JsonResponse
    {
        try {
            $total = stokpakan::sum('jumlah_pakan');
            
            return response()->json([
                'success' => true,
                'message' => 'Total stok pakan berhasil dihitung',
                'data' => [
                    'total_stok_pakan' => $total
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghitung total stok pakan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByNamaPakan($namaPakan): JsonResponse
    {
        try {
            $stokPakan = stokpakan::with('pengguna')
                ->where('nama_pakan', 'like', '%' . $namaPakan . '%')
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Stok pakan berdasarkan nama berhasil diambil',
                'data' => $stokPakan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil stok pakan berdasarkan nama',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
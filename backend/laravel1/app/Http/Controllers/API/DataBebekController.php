<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\databebek;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;

class DataBebekController extends Controller
{
    public function index(): JsonResponse
    {
        try {
            $dataBebek = databebek::with('pengguna')->get();
            return response()->json([
                'success' => true,
                'message' => 'Data bebek berhasil diambil',
                'data' => $dataBebek
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data bebek',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'pengguna_id' => 'required|exists:penggunas,id',
                'jumlah_bebek' => 'required|integer|min:1',
                'tanggal_input' => 'required|date',
                'status' => 'required|string',
                'tanggal_ambil' => 'nullable|date'
            ]);

            $dataBebek = databebek::create($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Data bebek berhasil ditambahkan',
                'data' => $dataBebek->load('pengguna')
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
                'message' => 'Gagal menambahkan data bebek',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id): JsonResponse
    {
        try {
            $dataBebek = databebek::with('pengguna')->findOrFail($id);
            
            return response()->json([
                'success' => true,
                'message' => 'Data bebek berhasil ditemukan',
                'data' => $dataBebek
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Data bebek tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function update(Request $request, $id): JsonResponse
    {
        try {
            $dataBebek = databebek::findOrFail($id);
            
            $validated = $request->validate([
                'pengguna_id' => 'sometimes|exists:penggunas,id',
                'jumlah_bebek' => 'sometimes|integer|min:1',
                'tanggal_input' => 'sometimes|date',
                'status' => 'sometimes|string',
                'tanggal_ambil' => 'nullable|date'
            ]);

            $dataBebek->update($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Data bebek berhasil diperbarui',
                'data' => $dataBebek->load('pengguna')
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
                'message' => 'Gagal memperbarui data bebek',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id): JsonResponse
    {
        try {
            $dataBebek = databebek::findOrFail($id);
            $dataBebek->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Data bebek berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus data bebek',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByPengguna($penggunaId): JsonResponse
    {
        try {
            $dataBebek = databebek::with('pengguna')
                ->where('pengguna_id', $penggunaId)
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Data bebek pengguna berhasil diambil',
                'data' => $dataBebek
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data bebek pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getTotalBebek(): JsonResponse
    {
        try {
            $total = databebek::sum('jumlah_bebek');
            
            return response()->json([
                'success' => true,
                'message' => 'Total bebek berhasil dihitung',
                'data' => [
                    'total_bebek' => $total
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghitung total bebek',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}

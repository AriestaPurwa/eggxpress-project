<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\infoharga;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;

class InfoHargaController extends Controller
{
    public function index(): JsonResponse
    {
        try {
            $infoHarga = infoharga::all();
            return response()->json([
                'success' => true,
                'message' => 'Info harga berhasil diambil',
                'data' => $infoHarga
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil info harga',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'jenis' => 'required|string|max:255',
                'harga' => 'required|numeric|min:0',
                'tanggal_update' => 'required|date'
            ]);

            $infoHarga = infoharga::create($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Info harga berhasil ditambahkan',
                'data' => $infoHarga
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
                'message' => 'Gagal menambahkan info harga',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id): JsonResponse
    {
        try {
            $infoHarga = infoharga::findOrFail($id);
            
            return response()->json([
                'success' => true,
                'message' => 'Info harga berhasil ditemukan',
                'data' => $infoHarga
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Info harga tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function update(Request $request, $id): JsonResponse
    {
        try {
            $infoHarga = infoharga::findOrFail($id);
            
            $validated = $request->validate([
                'jenis' => 'sometimes|string|max:255',
                'harga' => 'sometimes|numeric|min:0',
                'tanggal_update' => 'sometimes|date'
            ]);

            $infoHarga->update($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Info harga berhasil diperbarui',
                'data' => $infoHarga
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
                'message' => 'Gagal memperbarui info harga',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id): JsonResponse
    {
        try {
            $infoHarga = infoharga::findOrFail($id);
            $infoHarga->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Info harga berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus info harga',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByJenis($jenis): JsonResponse
    {
        try {
            $infoHarga = infoharga::where('jenis', $jenis)
                ->orderBy('tanggal_update', 'desc')
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Info harga berdasarkan jenis berhasil diambil',
                'data' => $infoHarga
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil info harga berdasarkan jenis',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getLatestPrices(): JsonResponse
    {
        try {
            $latestPrices = infoharga::select('jenis', 'harga', 'tanggal_update')
                ->whereIn('id', function($query) {
                    $query->selectRaw('MAX(id)')
                        ->from('info_hargas')
                        ->groupBy('jenis');
                })
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Harga terbaru berhasil diambil',
                'data' => $latestPrices
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil harga terbaru',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
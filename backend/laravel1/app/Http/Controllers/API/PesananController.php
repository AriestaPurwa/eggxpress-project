<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\pesanan;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;

class PesananController extends Controller
{
    public function index(): JsonResponse
    {
        try {
            $pesanan = pesanan::all();
            return response()->json([
                'success' => true,
                'message' => 'Data pesanan berhasil diambil',
                'data' => $pesanan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data pesanan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request): JsonResponse
    {
        try {
            // Validasi berdasarkan kolom yang kemungkinan ada di tabel pesanans
            $validated = $request->validate([
                'pengguna_id' => 'required|exists:penggunas,id',
                'produk' => 'required|string|max:255',
                'jumlah' => 'required|integer|min:1',
                'harga_total' => 'required|numeric|min:0',
                'status' => 'required|string',
                'tanggal_pesanan' => 'required|date',
                'alamat_pengiriman' => 'required|string'
            ]);

            $pesanan = pesanan::create($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Pesanan berhasil ditambahkan',
                'data' => $pesanan
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
                'message' => 'Gagal menambahkan pesanan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id): JsonResponse
    {
        try {
            $pesanan = pesanan::findOrFail($id);
            
            return response()->json([
                'success' => true,
                'message' => 'Data pesanan berhasil ditemukan',
                'data' => $pesanan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Pesanan tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function update(Request $request, $id): JsonResponse
    {
        try {
            $pesanan = pesanan::findOrFail($id);
            
            $validated = $request->validate([
                'pengguna_id' => 'sometimes|exists:penggunas,id',
                'produk' => 'sometimes|string|max:255',
                'jumlah' => 'sometimes|integer|min:1',
                'harga_total' => 'sometimes|numeric|min:0',
                'status' => 'sometimes|string',
                'tanggal_pesanan' => 'sometimes|date',
                'alamat_pengiriman' => 'sometimes|string'
            ]);

            $pesanan->update($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Pesanan berhasil diperbarui',
                'data' => $pesanan
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
                'message' => 'Gagal memperbarui pesanan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id): JsonResponse
    {
        try {
            $pesanan = pesanan::findOrFail($id);
            $pesanan->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Pesanan berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus pesanan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByStatus($status): JsonResponse
    {
        try {
            $pesanan = pesanan::where('status', $status)->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Pesanan berdasarkan status berhasil diambil',
                'data' => $pesanan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil pesanan berdasarkan status',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByPengguna($penggunaId): JsonResponse
    {
        try {
            $pesanan = pesanan::where('pengguna_id', $penggunaId)->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Pesanan pengguna berhasil diambil',
                'data' => $pesanan
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil pesanan pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getTotalPenjualan(): JsonResponse
    {
        try {
            $total = pesanan::sum('harga_total');
            
            return response()->json([
                'success' => true,
                'message' => 'Total penjualan berhasil dihitung',
                'data' => [
                    'total_penjualan' => $total
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghitung total penjualan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getPesananByDateRange(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'start_date' => 'required|date',
                'end_date' => 'required|date|after_or_equal:start_date'
            ]);

            $pesanan = pesanan::whereBetween('tanggal_pesanan', [$validated['start_date'], $validated['end_date']])
                ->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Pesanan berdasarkan rentang tanggal berhasil diambil',
                'data' => $pesanan
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
                'message' => 'Gagal mengambil pesanan berdasarkan rentang tanggal',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function updateStatus(Request $request, $id): JsonResponse
    {
        try {
            $pesanan = pesanan::findOrFail($id);
            
            $validated = $request->validate([
                'status' => 'required|string'
            ]);

            $pesanan->update($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Status pesanan berhasil diperbarui',
                'data' => $pesanan
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
                'message' => 'Gagal memperbarui status pesanan',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
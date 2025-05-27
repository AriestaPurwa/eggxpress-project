<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pengguna;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

class PenggunaController extends Controller
{
    public function index(): JsonResponse
    {
        try {
            $pengguna = Pengguna::with(['data_bebek', 'alat_ternak'])->get();
            return response()->json([
                'success' => true,
                'message' => 'Data pengguna berhasil diambil',
                'data' => $pengguna
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'email' => 'required|email|unique:penggunas,email',
                'password' => 'required|string|min:6',
                'nama' => 'required|string|max:255',
                'role' => 'required|string|in:admin,user,peternak',
                'no_hp' => 'nullable|string|max:20',
                'alamat' => 'nullable|string',
                'foto' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048'
            ]);

            $validated['password'] = Hash::make($validated['password']);

            if ($request->hasFile('foto')) {
                $validated['foto'] = $request->file('foto')->store('pengguna', 'public');
            }

            $pengguna = Pengguna::create($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Pengguna berhasil ditambahkan',
                'data' => $pengguna
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
                'message' => 'Gagal menambahkan pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id): JsonResponse
    {
        try {
            $pengguna = Pengguna::with(['data_bebek', 'alat_ternak'])->findOrFail($id);
            
            return response()->json([
                'success' => true,
                'message' => 'Data pengguna berhasil ditemukan',
                'data' => $pengguna
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Pengguna tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function update(Request $request, $id): JsonResponse
    {
        try {
            $pengguna = Pengguna::findOrFail($id);
            
            $validated = $request->validate([
                'email' => 'sometimes|email|unique:penggunas,email,' . $id,
                'password' => 'sometimes|string|min:6',
                'nama' => 'sometimes|string|max:255',
                'role' => 'sometimes|string|in:admin,user,peternak',
                'no_hp' => 'sometimes|string|max:20',
                'alamat' => 'sometimes|string',
                'foto' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048'
            ]);

            if (isset($validated['password'])) {
                $validated['password'] = Hash::make($validated['password']);
            }

            if ($request->hasFile('foto')) {
                // Hapus foto lama jika ada
                if ($pengguna->foto) {
                    Storage::disk('public')->delete($pengguna->foto);
                }
                $validated['foto'] = $request->file('foto')->store('pengguna', 'public');
            }

            $pengguna->update($validated);
            
            return response()->json([
                'success' => true,
                'message' => 'Pengguna berhasil diperbarui',
                'data' => $pengguna
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
                'message' => 'Gagal memperbarui pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id): JsonResponse
    {
        try {
            $pengguna = Pengguna::findOrFail($id);
            
            // Hapus foto jika ada
            if ($pengguna->foto) {
                Storage::disk('public')->delete($pengguna->foto);
            }
            
            $pengguna->delete();
            
            return response()->json([
                'success' => true,
                'message' => 'Pengguna berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getByRole($role): JsonResponse
    {
        try {
            $pengguna = Pengguna::where('role', $role)->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Pengguna berdasarkan role berhasil diambil',
                'data' => $pengguna
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil pengguna berdasarkan role',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function login(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'email' => 'required|email',
                'password' => 'required|string'
            ]);

            $pengguna = Pengguna::where('email', $validated['email'])->first();

            if (!$pengguna || !Hash::check($validated['password'], $pengguna->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Email atau password tidak valid'
                ], 401);
            }

            // Hilangkan password dari response untuk keamanan
            $userData = $pengguna->toArray();
            unset($userData['password']);

            return response()->json([
                'success' => true,
                'message' => 'Login berhasil',
                'data' => $userData
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
                'message' => 'Gagal melakukan login',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
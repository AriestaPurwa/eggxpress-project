<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Pengguna;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class RegisterController extends Controller
{
    public function register(Request $request)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:255',
            'email' => 'required|email|unique:penggunas,email', // Sesuaikan dengan tabel penggunas
            'password' => 'required|string|min:6|confirmed',
            'role' => 'nullable|string|in:admin,user,peternak', // Sesuaikan dengan PenggunaController
            'no_hp' => 'nullable|string|max:20',
            'alamat' => 'nullable|string',
            'foto' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        try {
            // Persiapkan data untuk disimpan
            $data = [
                'nama' => $request->nama,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'role' => $request->role ?? 'user', // Default role 'user'
                'no_hp' => $request->no_hp,
                'alamat' => $request->alamat,
            ];

            // Handle upload foto jika ada
            if ($request->hasFile('foto')) {
                $data['foto'] = $request->file('foto')->store('pengguna', 'public');
            }

            // Simpan data pengguna baru
            $pengguna = Pengguna::create($data);

            return response()->json([
                'success' => true,
                'message' => 'Pendaftaran berhasil',
                'data' => [
                    'id' => $pengguna->id,
                    'nama' => $pengguna->nama,
                    'email' => $pengguna->email,
                    'role' => $pengguna->role,
                    'no_hp' => $pengguna->no_hp,
                    'alamat' => $pengguna->alamat,
                    'foto' => $pengguna->foto,
                    'created_at' => $pengguna->created_at,
                ]
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat mendaftar',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
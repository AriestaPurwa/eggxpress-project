<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Pengguna;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Session;

class LoginController extends Controller
{
    public function showLoginForm()
    {
        return view('login'); // Pastikan file view login.blade.php ada
    }

    public function login(Request $request)
    {
        $request->validate([
            'username' => 'required',
            'password' => 'required',
        ]);

        $pengguna = Pengguna::where('username', $request->username)->first();

        if ($pengguna && Hash::check($request->password, $pengguna->password)) {
            // Simpan data pengguna ke session
            Session::put('pengguna_id', $pengguna->id);
            Session::put('pengguna_nama', $pengguna->nama);
            return redirect()->route('dashboard'); // Ganti dengan route tujuan setelah login
        }

        return back()->withErrors([
            'login_error' => 'Username atau password salah.',
        ]);
    }

    public function logout()
    {
        Session::flush();
        return redirect()->route('login');
    }
}

<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AlatTernakController;
use App\Http\Controllers\Api\DataBebekController;
use App\Http\Controllers\Api\InfoHargaController;
use App\Http\Controllers\Api\PenggunaController;
use App\Http\Controllers\Api\PesananController;
use App\Http\Controllers\Api\StokPakanController;
use App\Http\Controllers\Api\StokTelurController;
use App\Http\Controllers\Api\RegisterController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Authentication Routes
Route::post('/register', [RegisterController::class, 'register']);
Route::post('/login', [PenggunaController::class, 'login']);

// Pengguna Routes
Route::prefix('pengguna')->group(function () {
    Route::get('/', [PenggunaController::class, 'index']);
    Route::post('/', [PenggunaController::class, 'store']);
    Route::get('/{id}', [PenggunaController::class, 'show']);
    Route::put('/{id}', [PenggunaController::class, 'update']);
    Route::delete('/{id}', [PenggunaController::class, 'destroy']);
    Route::get('/role/{role}', [PenggunaController::class, 'getByRole']);
});

// Alat Ternak Routes
Route::prefix('alat-ternak')->group(function () {
    Route::get('/', [AlatTernakController::class, 'index']);
    Route::post('/', [AlatTernakController::class, 'store']);
    Route::get('/{id}', [AlatTernakController::class, 'show']);
    Route::put('/{id}', [AlatTernakController::class, 'update']);
    Route::delete('/{id}', [AlatTernakController::class, 'destroy']);
    Route::get('/pengguna/{penggunaId}', [AlatTernakController::class, 'getByPengguna']);
});

// Data Bebek Routes
Route::prefix('data-bebek')->group(function () {
    Route::get('/', [DataBebekController::class, 'index']);
    Route::post('/', [DataBebekController::class, 'store']);
    Route::get('/{id}', [DataBebekController::class, 'show']);
    Route::put('/{id}', [DataBebekController::class, 'update']);
    Route::delete('/{id}', [DataBebekController::class, 'destroy']);
    Route::get('/pengguna/{penggunaId}', [DataBebekController::class, 'getByPengguna']);
    Route::get('/total/bebek', [DataBebekController::class, 'getTotalBebek']);
});

// Info Harga Routes
Route::prefix('info-harga')->group(function () {
    Route::get('/', [InfoHargaController::class, 'index']);
    Route::post('/', [InfoHargaController::class, 'store']);
    Route::get('/{id}', [InfoHargaController::class, 'show']);
    Route::put('/{id}', [InfoHargaController::class, 'update']);
    Route::delete('/{id}', [InfoHargaController::class, 'destroy']);
    Route::get('/jenis/{jenis}', [InfoHargaController::class, 'getByJenis']);
    Route::get('/latest/prices', [InfoHargaController::class, 'getLatestPrices']);
});

// Pesanan Routes
Route::prefix('pesanan')->group(function () {
    Route::get('/', [PesananController::class, 'index']);
    Route::post('/', [PesananController::class, 'store']);
    Route::get('/{id}', [PesananController::class, 'show']);
    Route::put('/{id}', [PesananController::class, 'update']);
    Route::delete('/{id}', [PesananController::class, 'destroy']);
    Route::get('/status/{status}', [PesananController::class, 'getByStatus']);
    Route::get('/pengguna/{penggunaId}', [PesananController::class, 'getByPengguna']);
});

// Stok Pakan Routes
Route::prefix('stok-pakan')->group(function () {
    Route::get('/', [StokPakanController::class, 'index']);
    Route::post('/', [StokPakanController::class, 'store']);
    Route::get('/{id}', [StokPakanController::class, 'show']);
    Route::put('/{id}', [StokPakanController::class, 'update']);
    Route::delete('/{id}', [StokPakanController::class, 'destroy']);
    Route::get('/pengguna/{penggunaId}', [StokPakanController::class, 'getByPengguna']);
    Route::get('/total/stok', [StokPakanController::class, 'getTotalStok']);
    Route::get('/nama/{namaPakan}', [StokPakanController::class, 'getByNamaPakan']);
});

// Stok Telur Routes
Route::prefix('stok-telur')->group(function () {
    Route::get('/', [StokTelurController::class, 'index']);
    Route::post('/', [StokTelurController::class, 'store']);
    Route::get('/{id}', [StokTelurController::class, 'show']);
    Route::put('/{id}', [StokTelurController::class, 'update']);
    Route::delete('/{id}', [StokTelurController::class, 'destroy']);
    Route::get('/pengguna/{penggunaId}', [StokTelurController::class, 'getByPengguna']);
    Route::get('/total/telur', [StokTelurController::class, 'getTotalTelur']);
    Route::get('/kualitas/{kualitas}', [StokTelurController::class, 'getByKualitas']);
    Route::post('/date-range', [StokTelurController::class, 'getStokByDate']);
});

// Dashboard/Statistics Routes
Route::prefix('dashboard')->group(function () {
    Route::get('/statistics', function () {
        try {
            $totalBebek = \App\Models\databebek::sum('jumlah_bebek');
            $totalTelur = \App\Models\stoktelur::sum('jumlah_telur');
            $totalPakan = \App\Models\stokpakan::sum('jumlah_pakan');
            $totalPengguna = \App\Models\pengguna::count();
            $totalPesanan = \App\Models\pesanan::count();
            
            return response()->json([
                'success' => true,
                'message' => 'Statistik dashboard berhasil diambil',
                'data' => [
                    'total_bebek' => $totalBebek,
                    'total_telur' => $totalTelur,
                    'total_pakan' => $totalPakan,
                    'total_pengguna' => $totalPengguna,
                    'total_pesanan' => $totalPesanan
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil statistik dashboard',
                'error' => $e->getMessage()
            ], 500);
        }
    });
});

// General search endpoint
Route::get('/search', function (Request $request) {
    try {
        $query = $request->get('q');
        $type = $request->get('type', 'all');
        
        $results = [];
        
        if ($type === 'all' || $type === 'pengguna') {
            $results['pengguna'] = \App\Models\pengguna::where('nama', 'like', '%' . $query . '%')
                ->orWhere('email', 'like', '%' . $query . '%')
                ->limit(10)
                ->get();
        }
        
        if ($type === 'all' || $type === 'pakan') {
            $results['stok_pakan'] = \App\Models\stokpakan::where('nama_pakan', 'like', '%' . $query . '%')
                ->with('pengguna')
                ->limit(10)
                ->get();
        }
        
        if ($type === 'all' || $type === 'alat') {
            $results['alat_ternak'] = \App\Models\alatternak::where('nama_alat', 'like', '%' . $query . '%')
                ->with('pengguna')
                ->limit(10)
                ->get();
        }
        
        return response()->json([
            'success' => true,
            'message' => 'Pencarian berhasil',
            'data' => $results
        ], 200);
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'Gagal melakukan pencarian',
            'error' => $e->getMessage()
        ], 500);
    }
});

// Health check endpoint
Route::get('/health', function () {
    return response()->json([
        'success' => true,
        'message' => 'API is running properly',
        'timestamp' => now()->format('Y-m-d H:i:s')
    ], 200);
});
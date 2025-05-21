<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class stoktelur extends Model
{
    protected $table = 'stok_telurs';

    protected $fillable = [
        'pengguna_id',
        'jumlah_telur',
        'kualitas',
        'tanggal_input',
        'status',
        'tanggal_ambil',
    ];

    public function pengguna()
    {
        return $this->belongsTo(\App\Models\Pengguna::class);
    }
}

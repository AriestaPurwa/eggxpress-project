<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class stokpakan extends Model
{
    protected $table = 'stok_pakans';
    protected $fillable = [
        'pengguna_id',
        'nama_pakan',
        'jumlah_pakan',
        'tanggal_input',
        'status',
        'tanggal_ambil'
    ];

    public function pengguna()
    {
        return $this->belongsTo(pengguna::class);
    }
}

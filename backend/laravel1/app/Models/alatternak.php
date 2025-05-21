<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class alatternak extends Model
{
    protected $table = 'alat_ternaks';
    protected $fillable = [
        'pengguna_id',
        'nama_alat',
        'jumlah_alat',
        'tanggal_input',
        'status',
        'tanggal_ambil'
    ];

    public function pengguna()
    {
        return $this->belongsTo(pengguna::class);
    }
}

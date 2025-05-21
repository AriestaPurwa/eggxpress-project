<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class databebek extends Model
{
    protected $table = 'data_bebeks';
    protected $fillable = [
        'pengguna_id',
        'jumlah_bebek',
        'tanggal_input',
        'status',
        'tanggal_ambil'
    ];

    public function pengguna()
    {
        return $this->belongsTo(pengguna::class);
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class pengguna extends Model
{
    protected $table = 'penggunas';
    protected $fillable = [
        'email',
        'password',
        'nama',
        'role',
        'no_hp',
        'alamat',
        'foto', // Tambahkan ini
    ];

    public function data_bebek()
    {
        return $this->hasMany(data_bebek::class);
    }

    public function alat_ternak()
    {
        return $this->hasMany(alatTernak::class);
    }
}
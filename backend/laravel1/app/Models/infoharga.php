<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class infoharga extends Model
{
    protected $table = 'info_hargas';
    protected $fillable = [
        'jenis',
        'harga',
        'tanggal_update'
    ];

    public function jenis()
    {
        return $this->belongsTo(jenis::class);
    }
}

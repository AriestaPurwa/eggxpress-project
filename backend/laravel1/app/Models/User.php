<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\Relations\HasMany;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    // Relasi ke DataBebek
    public function dataBebek(): HasMany
    {
        return $this->hasMany(DataBebek::class, 'pengguna_id');
    }

    // Relasi ke Pesanan
    public function pesanans(): HasMany
    {
        return $this->hasMany(Pesanan::class, 'pengguna_id');
    }

    // Relasi ke StokTelur
    public function stokTelurs(): HasMany
    {
        return $this->hasMany(StokTelur::class, 'pengguna_id');
    }

    // Relasi ke StokPakan
    public function stokPakans(): HasMany
    {
        return $this->hasMany(StokPakan::class, 'pengguna_id');
    }
}

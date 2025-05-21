<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{

  public function up(): void{Schema::create('stok_telurs', function (Blueprint $table) {$table->id();$table->unsignedBigInteger('pengguna_id');$table->integer('jumlah_telur');$table->integer('kualitas');$table->date('tanggal_input');$table->string('status');$table->date('tanggal_ambil');$table->timestamps();

            $table->foreign('pengguna_id')->references('id')->on('penggunas')->onDelete('cascade');
        });
    }


  public function down(): void{Schema::dropIfExists('stok_telurs');}
};
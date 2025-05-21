<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('stok_pakans', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('pengguna_id');
            $table->integer('jenis_pakan');
            $table->integer('jumlah_pakan');
            $table->date('tanggal_input');
            $table->string('status');
            $table->date('tanggal_ambil');
            $table->timestamps();

            $table->foreign('pengguna_id')->references('id')->on('penggunas')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('stok_pakans');
    }
};

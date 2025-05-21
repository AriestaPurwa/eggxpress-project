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
        Schema::create('pesanans', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pengguna_id')->constrained('penggunas')->onDelete('cascade');
            $table->integer('jumlah'); // typo: 'jumalah' (mungkin maksudnya 'jumlah')
            $table->float('total_harga');
            $table->date('tanggal_pesan');
            $table->string('status');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pesanans');
    }
};

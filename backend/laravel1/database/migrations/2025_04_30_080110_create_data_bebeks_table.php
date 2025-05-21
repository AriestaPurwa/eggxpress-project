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
        Schema::create('data_bebeks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('pengguna_id')->unique()->constrained('penggunas');
            $table->integer('jumlah_bebek');
            $table->date('tanggal_input');
            $table->string('status');
            $table->date('tanggal_ambil');
            $table->timestamps();

            $table->foreign('pengguna_id', 'fk_data_bebeks_pengguna_id')
      ->references('id')->on('penggunas')->onDelete('cascade');

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('data_bebeks');
    }
};

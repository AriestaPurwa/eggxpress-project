<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    
     
  public function up(): void {
    Schema::create('penggunas', function (Blueprint $table) {
      $table->id();
      $table->string('email');
      $table->string('password');
      $table->string('nama');
      $table->string('role');
      $table->string('no_hp');
      $table->string('alamat');
      $table->string('foto')->nullable(); // Tambahkan ini
      $table->timestamps();});}

    
     

  public function down(): void{Schema::dropIfExists('penggunas');}
};
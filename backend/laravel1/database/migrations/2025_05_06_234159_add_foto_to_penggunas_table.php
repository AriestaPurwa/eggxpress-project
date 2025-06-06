<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;


return new class extends Migration {
public function up()
{
    if (!Schema::hasColumn('penggunas', 'foto')) {
        Schema::table('penggunas', function (Blueprint $table) {
            $table->string('foto')->nullable()->after('alamat');
        });
    }
}

    public function down(): void
    {
        Schema::table('penggunas', function (Blueprint $table) {
            $table->dropColumn('foto');
        });
    }
};



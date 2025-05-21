<?php

namespace App\Filament\Widgets;

use App\Models\Pengguna;
use App\Models\StokTelur;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;
use Illuminate\Support\Carbon;

class StatsDashboard extends BaseWidget
{
    protected function getStats(): array
    {
        $totalPengguna = Pengguna::count();
        $totalStokTelur = StokTelur::sum('jumlah_telur');
        $telurDiambil = StokTelur::whereNotNull('tanggal_ambil')->sum('jumlah_telur');

        return [
            Stat::make('Total Pengguna', $totalPengguna)
                ->description('Jumlah seluruh pengguna')
                ->icon('heroicon-o-users')
                ->color('primary'),

            Stat::make('Total Stok Telur', $totalStokTelur . ' butir')
                ->description('Jumlah seluruh stok telur')
                ->icon('heroicon-o-circle-stack')
                ->color('success'),

            Stat::make('Telur Diambil', $telurDiambil . ' butir')
                ->description('Jumlah telur yang sudah diambil')
                ->icon('heroicon-o-check-circle')
                ->color('danger'),
        ];
    }
}

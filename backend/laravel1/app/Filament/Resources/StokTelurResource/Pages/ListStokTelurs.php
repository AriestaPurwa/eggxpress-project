<?php

namespace App\Filament\Resources\StokTelurResource\Pages;

use App\Filament\Resources\StokTelurResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListStokTelurs extends ListRecords
{
    protected static string $resource = StokTelurResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}

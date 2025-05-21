<?php

namespace App\Filament\Resources\InfoHargaResource\Pages;

use App\Filament\Resources\InfoHargaResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListInfoHargas extends ListRecords
{
    protected static string $resource = InfoHargaResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}

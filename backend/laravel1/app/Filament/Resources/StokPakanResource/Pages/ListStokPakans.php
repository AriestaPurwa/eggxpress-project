<?php

namespace App\Filament\Resources\StokPakanResource\Pages;

use App\Filament\Resources\StokPakanResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListStokPakans extends ListRecords
{
    protected static string $resource = StokPakanResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}

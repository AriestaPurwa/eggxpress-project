<?php

namespace App\Filament\Resources\PenggunaResource\Pages;

use App\Filament\Resources\PenggunaResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListPenggunas extends ListRecords
{
    protected static string $resource = PenggunaResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}

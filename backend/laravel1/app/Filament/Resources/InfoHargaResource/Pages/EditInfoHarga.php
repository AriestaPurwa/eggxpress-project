<?php

namespace App\Filament\Resources\InfoHargaResource\Pages;

use App\Filament\Resources\InfoHargaResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditInfoHarga extends EditRecord
{
    protected static string $resource = InfoHargaResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}

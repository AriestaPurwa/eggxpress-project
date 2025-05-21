<?php

namespace App\Filament\Resources\AlatTernakResource\Pages;

use App\Filament\Resources\AlatTernakResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditAlatTernak extends EditRecord
{
    protected static string $resource = AlatTernakResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}

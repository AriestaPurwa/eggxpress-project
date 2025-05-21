<?php

namespace App\Filament\Resources\DataBebekResource\Pages;

use App\Filament\Resources\DataBebekResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditDataBebek extends EditRecord
{
    protected static string $resource = DataBebekResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}

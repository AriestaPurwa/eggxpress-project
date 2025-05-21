<?php

namespace App\Filament\Resources\DataBebekResource\Pages;

use App\Filament\Resources\DataBebekResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListDataBebeks extends ListRecords
{
    protected static string $resource = DataBebekResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}

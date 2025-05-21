<?php

namespace App\Filament\Resources;

use App\Filament\Resources\InfoHargaResource\Pages;
use App\Models\InfoHarga;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class InfoHargaResource extends Resource
{
    protected static ?string $model = InfoHarga::class;

    protected static ?string $navigationIcon = 'heroicon-o-presentation-chart-line';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('jenis')
                    ->required()
                    ->numeric(),

                Forms\Components\TextInput::make('harga')
                    ->required()
                    ->numeric(),

                Forms\Components\DatePicker::make('tanggal_update')
                    ->required(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id')->sortable()->searchable(),
                Tables\Columns\TextColumn::make('jenis'),
                Tables\Columns\TextColumn::make('harga'),
                Tables\Columns\TextColumn::make('tanggal_update')->date(),
                Tables\Columns\TextColumn::make('created_at')->dateTime(),
                Tables\Columns\TextColumn::make('updated_at')->dateTime(),
            ])
            ->filters([])
            ->actions([
                Tables\Actions\EditAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getRelations(): array
    {
        return [];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListInfoHargas::route('/'),
            'create' => Pages\CreateInfoHarga::route('/create'),
            'edit' => Pages\EditInfoHarga::route('/{record}/edit'),
        ];
    }
}

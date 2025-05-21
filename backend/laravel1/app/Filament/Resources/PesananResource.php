<?php

namespace App\Filament\Resources;

use App\Filament\Resources\PesananResource\Pages;
use App\Models\Pesanan;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class PesananResource extends Resource
{
    protected static ?string $model = Pesanan::class;

    protected static ?string $navigationIcon = 'heroicon-o-shopping-bag';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('pengguna_id')
                    ->required()
                    ->numeric(),

                Forms\Components\TextInput::make('jumlah')
                    ->required()
                    ->numeric(),

                Forms\Components\TextInput::make('total_harga')
                    ->required()
                    ->numeric(),

                Forms\Components\DatePicker::make('tanggal_pesan')
                    ->required(),

                Forms\Components\TextInput::make('status')
                    ->required()
                    ->maxLength(255),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id')->sortable()->searchable(),
                Tables\Columns\TextColumn::make('pengguna_id')->sortable()->searchable(),
                Tables\Columns\TextColumn::make('jumlah'),
                Tables\Columns\TextColumn::make('total_harga'),
                Tables\Columns\TextColumn::make('tanggal_pesan')->date(),
                Tables\Columns\TextColumn::make('status'),
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
            'index' => Pages\ListPesanans::route('/'),
            'create' => Pages\CreatePesanan::route('/create'),
            'edit' => Pages\EditPesanan::route('/{record}/edit'),
        ];
    }
}

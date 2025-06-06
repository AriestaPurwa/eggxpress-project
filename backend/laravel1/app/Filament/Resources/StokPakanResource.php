<?php

namespace App\Filament\Resources;

use App\Filament\Resources\StokPakanResource\Pages;
use App\Models\StokPakan;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class StokPakanResource extends Resource
{
    protected static ?string $model = StokPakan::class;

    protected static ?string $navigationIcon = 'heroicon-o-clipboard-document-list';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('pengguna_id')
                    ->required()
                    ->numeric(),

                Forms\Components\TextInput::make('jenis_pakan')
                    ->required()
                    ->numeric(),

                Forms\Components\TextInput::make('jumlah_pakan')
                    ->required()
                    ->numeric(),

                Forms\Components\DatePicker::make('tanggal_input')
                    ->required(),

                Forms\Components\TextInput::make('status')
                    ->required()
                    ->maxLength(255),

                Forms\Components\DatePicker::make('tanggal_ambil')
                    ->required(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id')->sortable()->searchable(),
                Tables\Columns\TextColumn::make('pengguna_id')->sortable()->searchable(),
                Tables\Columns\TextColumn::make('jenis_pakan'),
                Tables\Columns\TextColumn::make('jumlah_pakan'),
                Tables\Columns\TextColumn::make('tanggal_input')->date(),
                Tables\Columns\TextColumn::make('status'),
                Tables\Columns\TextColumn::make('tanggal_ambil')->date(),
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
            'index' => Pages\ListStokPakans::route('/'),
            'create' => Pages\CreateStokPakan::route('/create'),
            'edit' => Pages\EditStokPakan::route('/{record}/edit'),
        ];
    }
}

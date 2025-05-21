<?php

namespace App\Filament\Resources;

use App\Filament\Resources\AlatTernakResource\Pages;
use App\Models\AlatTernak;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class AlatTernakResource extends Resource
{
    protected static ?string $model = AlatTernak::class;

    protected static ?string $navigationIcon = 'heroicon-o-wrench-screwdriver';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('pengguna_id')
                    ->required()
                    ->numeric(),

                Forms\Components\TextInput::make('nama_alat')
                    ->required()
                    ->maxLength(255), // ← sudah bukan numeric

                Forms\Components\TextInput::make('jumlah_alat')
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
                Tables\Columns\TextColumn::make('nama_alat')->searchable(),
                Tables\Columns\TextColumn::make('jumlah_alat'),
                Tables\Columns\TextColumn::make('tanggal_input')->date(),
                Tables\Columns\TextColumn::make('status'),
                Tables\Columns\TextColumn::make('tanggal_ambil')->date(),
                Tables\Columns\TextColumn::make('created_at')->dateTime(),
                Tables\Columns\TextColumn::make('updated_at')->dateTime(),
            ])
            ->filters([
                //
            ])
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
            'index' => Pages\ListAlatTernaks::route('/'),
            'create' => Pages\CreateAlatTernak::route('/create'),
            'edit' => Pages\EditAlatTernak::route('/{record}/edit'),
        ];
    }
}

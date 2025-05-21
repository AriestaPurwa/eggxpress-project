<?php

namespace App\Filament\Resources;

use App\Filament\Resources\StokTelurResource\Pages;
use App\Models\StokTelur;
use App\Models\User;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class StokTelurResource extends Resource
{
    protected static ?string $model = StokTelur::class;

    protected static ?string $navigationIcon = 'heroicon-o-list-bullet';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('pengguna_id')
                ->label('Nama Pengguna')
                ->relationship('pengguna', 'nama') // ganti 'nama' jika kolom nama di tabel 'penggunas' bernama 'nama'
                    ->searchable()
                    ->preload()
                    ->required(),


                Forms\Components\TextInput::make('jumlah_telur')
                    ->required()
                    ->numeric(),

                Forms\Components\Select::make('kualitas')
                    ->label('Kualitas Telur')
                    ->options([
                        1 => 'Bagus',
                        2 => 'Sedang',
                        3 => 'Buruk',
                    ])
                    ->required(),

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
                Tables\Columns\TextColumn::make('pengguna.nama')->label('Nama Pengguna')->sortable()->searchable(),
                Tables\Columns\TextColumn::make('jumlah_telur'),
                Tables\Columns\TextColumn::make('kualitas')
                    ->formatStateUsing(fn ($state) => match ($state) {
                        1 => 'Bagus',
                        2 => 'Sedang',
                        3 => 'Buruk',
                        default => 'Tidak Diketahui',
                    }),
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
            'index' => Pages\ListStokTelurs::route('/'),
            'create' => Pages\CreateStokTelur::route('/create'),
            'edit' => Pages\EditStokTelur::route('/{record}/edit'),
        ];
    }
}

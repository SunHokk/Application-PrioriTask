import {
  IsString,
  IsNotEmpty,
  IsEnum,
  IsDateString,
  IsOptional,
  IsNumber,
  Min,
  Max,
  IsBoolean,
} from 'class-validator';

export enum Difficulty {
  EASY = 'easy',
  MEDIUM = 'medium',
  HARD = 'hard',
}

export class CreateTaskDto {
  @IsString()
  @IsNotEmpty()
  subject_name: string;

  @IsString()
  @IsNotEmpty()
  task_name: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsEnum(Difficulty)
  difficulty: Difficulty;

  @IsDateString()
  deadline: string;
}

export class UpdateTaskDto {
  @IsString()
  @IsOptional()
  subject_name?: string;

  @IsString()
  @IsOptional()
  task_name?: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsEnum(Difficulty)
  @IsOptional()
  difficulty?: Difficulty;

  @IsDateString()
  @IsOptional()
  deadline?: string;

  @IsNumber()
  @Min(0)
  @Max(100)
  @IsOptional()
  progress_percent?: number;

  @IsBoolean()
  @IsOptional()
  is_completed?: boolean;
}

export class CreateProgressUpdateDto {
  @IsNumber()
  @Min(0)
  @Max(100)
  progress_percent: number;

  @IsString()
  @IsOptional()
  note?: string;

  @IsString()
  @IsOptional()
  image_url?: string;
}

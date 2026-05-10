export class CreateTaskDto {
  title!: string;
  courseName!: string;
  difficulty!: number;
  deadline!: string;
  description?: string; // Tanda tanya tetap untuk yang opsional
}
import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth';

@Component({
  selector: 'app-register',
  imports: [ReactiveFormsModule, RouterLink],
  templateUrl: './register.html',
  styleUrl: './register.css',
})
export class Register {
  private fb = inject(FormBuilder);
  private auth = inject(AuthService);
  private router = inject(Router);

  erreur = '';
  photoPreview = '';

  form = this.fb.group({
    nom: ['', Validators.required],
    prenom: ['', Validators.required],
    email: ['', [Validators.required, Validators.email]],
    telephone: ['', [Validators.required, Validators.pattern(/^[0-9]{8}$/)]],
    dateNaissance: ['', Validators.required],
    role: ['client'],
    specialite: [''],
    experience: [0],
    diplome: [''],
    bio: ['', Validators.maxLength(200)],
    password: ['', [Validators.required, Validators.minLength(6)]],
    confirm: ['', Validators.required],
  });

  get estCoach() {
    return this.form.value.role === 'coach';
  }

  get bioLength() {
    return this.form.value.bio?.length ?? 0;
  }

  changerExperience(delta: number) {
    const actuel = this.form.controls.experience.value ?? 0;
    this.form.controls.experience.setValue(Math.max(0, actuel + delta));
  }



  onSubmit() {
    this.erreur = '';
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    const v = this.form.value;
    if (v.password !== v.confirm) {
      this.erreur = 'Les mots de passe ne correspondent pas';
      return;
    }
    if (this.estCoach && !v.specialite) {
      this.erreur = 'Veuillez choisir votre spécialité';
      return;
    }
    if (this.estCoach && !v.diplome) {
      this.erreur = 'Veuillez indiquer votre diplôme';
      return;
    }
    this.auth.register(v).subscribe({
      next: () => this.router.navigate(['/login']),
      error: (err: any) => {
  this.erreur = err.error?.message || 'Erreur lors de l inscription';
}
    });
  }
}
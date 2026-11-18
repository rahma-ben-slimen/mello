
import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth';

@Component({
  selector: 'app-login',
  imports: [ReactiveFormsModule, RouterLink],
  templateUrl: './login.html',
  styleUrl: './login.css',
})
export class Login {
  private fb = inject(FormBuilder);
  private auth = inject(AuthService);
  private router = inject(Router);

  erreur = '';
  loading = false;

  form = this.fb.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(6)]],
  });

  onSubmit() {
    console.log('Login function called');

    this.erreur = '';

    if (this.form.invalid) {
      this.form.markAllAsTouched();
      console.log('Form is invalid');
      return;
    }

    const { email, password } = this.form.value;

    this.loading = true;

    this.auth.login(email!, password!).subscribe({
      next: (response) => {
        console.log('LOGIN SUCCESS:', response);
        localStorage.setItem('token', response.token);
        localStorage.setItem('user', JSON.stringify(response.user));

        this.loading = false;

        alert('Welcome to Mello!');
      },
      error: (err) => {
        console.error('LOGIN ERROR:', err);
        this.loading = false;
        this.erreur =
          'Login failed. Please try again.';
      }
    });
  }
}

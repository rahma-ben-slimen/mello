
const db = require('../config/bd');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// REGISTER
const register = (req, res) => {

    const {
        nom, prenom, email, password,
        dateNaissance, telephone, role,
        specialite, experience, diplome, bio
    } = req.body;

    // Vérification des champs
    if (!nom || !prenom || !email || !password ||
        !dateNaissance || !telephone || !role) {
        return res.status(400).json({
            message: 'All fields are required'
        });
    }

    const userRole = String(role).toUpperCase();

    if (userRole !== 'CLIENT' && userRole !== 'COACH') {
        return res.status(400).json({
            message: 'Invalid role'
        });
    }

    if (userRole === 'COACH' && (!specialite || !diplome)) {
        return res.status(400).json({
            message: 'Specialty and diplome are required'
        });
    }

    // Vérification de l'email
    db.query(
        'SELECT * FROM users WHERE email = ?',
        [email],
        (err, users) => {

            if (users.length > 0) {
                return res.status(409).json({
                    message: 'Email already exists'
                });
            }

            bcrypt.hash(password, 10, (err, hash) => {

                if (err) {
                    return res.status(500).json({
                        message: 'Password error'
                    });
                }

                const sql = `
                    INSERT INTO users
                    (nom, prenom, email, mdp, role, dateNaissance, tel)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                `;

                const values = [
                    nom, prenom, email, hash,
                    userRole, dateNaissance, telephone
                ];

                db.query(sql, values, (err, result) => {

                    if (err) {
                        return res.status(500).json({
                            message: 'Registration failed'
                        });
                    }

                    const userId = result.insertId;
                    if (userRole === 'CLIENT') {

                        db.query(
                            'INSERT INTO client (id) VALUES (?)',
                            [userId],
                            (err) => {

                                if (err) {
                                    return res.status(500).json({
                                        message: 'Client creation failed'
                                    });
                                }

                                return res.status(201).json({
                                    message: 'Registration successful',
                                    userId: userId
                                });
                            }
                        );
                    }


                    else {
                        const profileSQL = `
                            INSERT INTO coach
                            (id, specialite, biographie, experience, diplome)
                            VALUES (?, ?, ?, ?, ?)
                        `;

                        const profileValues = [
                            userId,
                            specialite,
                            bio || null,
                            experience || 0,
                            diplome
                        ];

                        db.query(profileSQL, profileValues, (err) => {

                            if (err) {
                                return res.status(500).json({
                                    message: 'Coach creation failed'
                                });
                            }

                            return res.status(201).json({
                                message: 'Registration successful',
                                userId: userId
                            });
                        });
                    }
                });
            });
        }
    );
};



const login = (req, res) => {

    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({
            message: 'Email and password are required'
        });
    }

    db.query(
        'SELECT * FROM users WHERE email = ?',
        [email],
        (err, users) => {

            if (err) {
                return res.status(500).json({
                    message: 'Database error'
                });
            }

            if (users.length === 0) {
                return res.status(401).json({
                    message: 'Invalid email or password'
                });
            }

            const user = users[0];

            bcrypt.compare(password, user.mdp, (err, isMatch) => {

                if (err || !isMatch) {
                    return res.status(401).json({
                        message: 'Invalid email or password'
                    });
                }


                const token = jwt.sign(
                    {
                        id: user.id,
                        role: user.role
                    },
                    process.env.JWT_SECRET,
                    { expiresIn: '1d' }
                );

                return res.status(200).json({
                    message: 'Login successful',
                    token: token,
                    user: {
                        id: user.id,
                        nom: user.nom,
                        prenom: user.prenom,
                        email: user.email,
                        role: user.role
                    }
                });
            });
        }
    );
};

module.exports = { register, login };

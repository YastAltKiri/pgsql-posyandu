require('dotenv').config();
const express = require('express');
const anakRoutes = require('./routes/anak.routes');

const app = express();
app.use(express.json());

app.get('/', (req, res) => res.json({ message: 'API SIPOSYANDU berjalan' }));
app.use('/api/anak', anakRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server berjalan di http://localhost:${PORT}`));

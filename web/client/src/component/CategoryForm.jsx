import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useNavigate, useParams } from 'react-router-dom';
import { toast } from 'react-toastify';
import {
    Container,
    Box,
    TextField,
    Button,
    Typography,
    Alert,
} from '@mui/material';
import Navbar from './Navbar';

const CategoryForm = ({
    initialName_en = "",
    initialName_ar = "",
    isUpdate = false,
    getUser = () => {},
}) => {
    const [name_en, setNameEn] = useState(initialName_en);
    const [name_ar, setNameAr] = useState(initialName_ar);
    const [errors, setErrors] = useState({});
    const navigate = useNavigate();
    const { id } = useParams();

    useEffect(() => {
        getUser();
        //console.log("----------------")
        //console.log(name_en)

    }, []);

    const handleSubmit = async (e) => {
        e.preventDefault();

        const url = `http://localhost:8000/api/categories${isUpdate ? `/${id}` : ''}`;
        const method = isUpdate ? axios.patch : axios.post;

        try {
            const res = await method(url, { name_en, name_ar }, { withCredentials: true });
            console.log(res.data.category);
            toast.success(`Category ${isUpdate ? 'updated' : 'created'} successfully!`);
            navigate('/admin/categories');
        } catch (err) {
            console.error(err);
            // console.error(err.response.data.error.errors);
            // const errs = err.response.data.error.errors;
            // const newErrors = {};
            // for (let key in errs) {
            //     newErrors[key] = errs[key].message;
            // }
            // setErrors(newErrors);
        }
    };

    return (
        <div>
            <Navbar index={1} />
            <Container maxWidth="sm">
                <Box
                    sx={{
                        bgcolor: '#ffffff',
                        padding: 4,
                        borderRadius: 2,
                        boxShadow: 3,
                        mt: 4,
                    }}
                >
                    <Typography variant="h5" align="center" gutterBottom>
                        {isUpdate ? 'Update' : 'Create'} Category
                    </Typography>
                    <form onSubmit={handleSubmit}>
                        <Box mb={2}>
                            {/* {errors.name_en && <Alert severity="error">{errors.name_en}</Alert>} */}
                            <TextField
                                label="Name (English)"
                                variant="outlined"
                                fullWidth
                                value={name_en}
                                onChange={(e) => setNameEn(e.target.value)}
                                error={!!errors.name_en}
                                helperText={errors.name_en}
                            />
                        </Box>
                        <Box mb={2}>
                            {/* {errors.name_ar && <Alert severity="error">{errors.name_ar}</Alert>} */}
                            <TextField
                                label="Name (Arabic)"
                                variant="outlined"
                                fullWidth
                                value={name_ar}
                                onChange={(e) => setNameAr(e.target.value)}
                                error={!!errors.name_ar}
                                helperText={errors.name_ar}
                            />
                        </Box>
                        <Button
                            type="submit"
                            variant="contained"
                            color="primary"
                            fullWidth
                        >
                            {isUpdate ? 'Update' : 'Create'}
                        </Button>
                    </form>
                </Box>
            </Container>
        </div>
    );
};

export default CategoryForm;
